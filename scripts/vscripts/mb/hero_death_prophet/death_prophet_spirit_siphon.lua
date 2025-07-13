---------------------------------
-- Death Prophet Spirit Siphon --
---------------------------------

imba_death_prophet_spirit_siphon = class({})

LinkLuaModifier("modifier_imba_death_prophet_spirit_siphon", "mb/hero_death_prophet/death_prophet_spirit_siphon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_prophet_spirit_siphon_buff", "mb/hero_death_prophet/death_prophet_spirit_siphon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_prophet_spirit_siphon_debuff", "mb/hero_death_prophet/death_prophet_spirit_siphon.lua", LUA_MODIFIER_MOTION_NONE)

function imba_death_prophet_spirit_siphon:IsHiddenWhenStolen() 	return false end
function imba_death_prophet_spirit_siphon:IsRefreshable() 			return true end
function imba_death_prophet_spirit_siphon:IsStealable() 			return true end
function imba_death_prophet_spirit_siphon:IsNetherWardStealable()	return true end

function imba_death_prophet_spirit_siphon:CastFilterResultTarget(target)
	if target == self:GetCaster() or target:IsBuilding() or target:IsOther() or target:IsCourier() then
		return UF_FAIL_CUSTOM
	end
	if IsServer() then
		local buffs = self:GetCaster():FindAllModifiersByName("modifier_imba_death_prophet_spirit_siphon")
		for _, buff in pairs(buffs) do
			if target:entindex() == buff:GetStackCount() then
				return UF_FAIL_CUSTOM
			end
		end

		local nResult = UnitFilter(
			target,
			DOTA_UNIT_TARGET_TEAM_BOTH,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			self:GetCaster():GetTeamNumber()
		) 

		if nResult ~= UF_SUCCESS then
			return nResult
		end
		return UF_SUCCESS
	end
end

function imba_death_prophet_spirit_siphon:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	else
		return "#dota_hud_error_cant_cast_on_other"
	end
end

function imba_death_prophet_spirit_siphon:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_death_prophet/death_prophet_spiritsiphon.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context )
end

--[[function imba_death_prophet_spirit_siphon:OnUpgrade()
	--充能设置
	if not AbilityChargeController:IsChargeTypeAbility(self) then
		AbilityChargeController:AbilityChargeInitialize(self, self:GetSpecialValueFor("charge_restore_time"), self:GetSpecialValueFor("max_charges"), 1, true, true)
	else
		AbilityChargeController:ChangeChargeAbilityConfig(self, self:GetSpecialValueFor("charge_restore_time"), self:GetSpecialValueFor("max_charges"), 1, true, true)
	end
end]]

function imba_death_prophet_spirit_siphon:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():GetCastRangeBonus()
end

function imba_death_prophet_spirit_siphon:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TG_TriggerSpellAbsorb(self) then
		return
	end
	local target_ent = target:entindex()
	if IsEnemy(caster, target) then
		caster:AddNewModifier(caster, self, "modifier_imba_death_prophet_spirit_siphon", {target = target_ent, duration = self:GetSpecialValueFor("haunt_duration")})
	else
		--可以对友军释放，持续时间内 治疗队友和提高队友移速
		target_ent = caster:entindex()
		caster:AddNewModifier(target, self, "modifier_imba_death_prophet_spirit_siphon", {target = target_ent, ally = 1, duration = self:GetSpecialValueFor("haunt_duration")})
	end
	caster:EmitSound("Hero_DeathProphet.SpiritSiphon.Cast")
	target:EmitSound("Hero_DeathProphet.SpiritSiphon.Target")
	--target:EmitSound("Hero_DeathProphet.SpiritSiphon.Loop")
	if not caster:HasModifier("modifier_imba_death_prophet_spirit_siphon") then
		caster:EmitSound("Hero_DeathProphet.SpiritSiphon.Loop")
	end
end

modifier_imba_death_prophet_spirit_siphon = class({})

function modifier_imba_death_prophet_spirit_siphon:IsDebuff()			return false end
function modifier_imba_death_prophet_spirit_siphon:IsHidden() 			return true end
function modifier_imba_death_prophet_spirit_siphon:IsPurgable() 		return false end
function modifier_imba_death_prophet_spirit_siphon:IsPurgeException() 	return false end
function modifier_imba_death_prophet_spirit_siphon:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_death_prophet_spirit_siphon:OnCreated(keys)
	if IsServer() then
		--计时器
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_rate"))
		self.target = EntIndexToHScript(keys.target)
		self.ally   = keys.ally
		--特效
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_spiritsiphon.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_ROOTBONE_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true)
		--if self.ally then
		--	--ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		--	ParticleManager:SetParticleContro(self.pfx, 1, self.ally:GetOrigin())
		--end
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self.target, PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", self.target:GetOrigin(), false)
		--ParticleManager:SetParticleControl(self.pfx, 1, self.target:GetOrigin() + Vector(0,0,200))
		--ParticleManager:SetParticleControlEnt(self.pfx, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.pfx, 5, Vector(self:GetDuration(),0,0))
		--ParticleManager:SetParticleControl(self.pfx, 11, Vector(0,0,0))
		local ent = keys.target
		if self:GetCaster() ~= self:GetAbility():GetCaster() then
			ent = self:GetCaster():entindex()
		end
		self:SetStackCount(ent)
	end
end

function modifier_imba_death_prophet_spirit_siphon:OnIntervalThink()
	--print("Start Siphon ~~~",self:GetAbility():GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster()) , (self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D())
	local caster = self:GetCaster()
	local target = self.target
	local spirit_siphon_distance = self:GetAbility():GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster()) + self:GetAbility():GetSpecialValueFor("siphon_buffer")
	if (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > (spirit_siphon_distance) or not target:IsAlive() or target:IsOutOfGame() then
		--print("Siphon Stop ~~~")
		self:Destroy()
		return
	end

	local ability = self:GetAbility()
	local dmg = (ability:GetSpecialValueFor("damage") + ((ability:GetSpecialValueFor("damage_pct") + caster:TG_GetTalentValue("special_bonus_imba_death_prophet_3")) / 100) * target:GetMaxHealth() or 0) / (1.0 / ability:GetSpecialValueFor("tick_rate"))
	if self.ally then
		dmg = dmg / 2
	end
	local damageTable = {
						victim = target,
						attacker = caster,
						damage = dmg,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self:GetAbility(), --Optional.
						}
	local dmg_done = ApplyDamage(damageTable)
	if self.ally then
		dmg_done = dmg_done * 2
	end
	if caster:GetHealth() ~= caster:GetMaxHealth() then
		ParticleManager:SetParticleControl(self.pfx, 11, Vector(0,0,0))
		caster:Heal(dmg_done, ability)
	else
		ParticleManager:SetParticleControl(self.pfx, 11, Vector(1,0,0))
		caster:SetMana(math.min(caster:GetMaxMana(), caster:GetMana() + dmg_done))
	end
	--窃取移速或者护甲
	if not self.ally then 
		target:AddNewModifier(caster, self:GetAbility(), "modifier_imba_death_prophet_spirit_siphon_debuff", {duration = self:GetAbility():GetSpecialValueFor("steal_duration")})
		target:SetModifierStackCount("modifier_imba_death_prophet_spirit_siphon_debuff", nil, target:GetModifierStackCount("modifier_imba_death_prophet_spirit_siphon_debuff", nil) + self:GetAbility():GetSpecialValueFor("steal_armor"))
		--魔晶恐惧
		if self:GetCaster():Has_Aghanims_Shard() and math.mod(target:GetModifierStackCount("modifier_imba_death_prophet_spirit_siphon_debuff", nil), self:GetAbility():GetSpecialValueFor("fear_tick")) == 0 then
			target:AddNewModifier(caster, self, "modifier_nevermore_requiem_fear", {duration = self:GetAbility():GetSpecialValueFor("fear_duration")})
		end
	end	
	caster:AddNewModifier(caster, self:GetAbility(), "modifier_imba_death_prophet_spirit_siphon_buff", {duration = self:GetAbility():GetSpecialValueFor("steal_duration")})
	caster:SetModifierStackCount("modifier_imba_death_prophet_spirit_siphon_buff", nil, caster:GetModifierStackCount("modifier_imba_death_prophet_spirit_siphon_buff", nil) + self:GetAbility():GetSpecialValueFor("steal_armor"))
end

function modifier_imba_death_prophet_spirit_siphon:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
		self.target:RemoveModifierByName("modifier_death_prophet_spirit_siphon_slow")
		self.target = nil
		self.pfx = nil
		self:GetCaster():StopSound("Hero_DeathProphet.SpiritSiphon.Cast")
		self:GetParent():StopSound("Hero_DeathProphet.SpiritSiphon.Target")
		--self:GetParent():StopSound("Hero_DeathProphet.SpiritSiphon.Loop")
		if not self:GetCaster():HasModifier("modifier_imba_death_prophet_spirit_siphon") then
			--self:GetCaster():StopSound("Hero_DeathProphet.SpiritSiphon.Loop")
		end
	end
end

--Value Shard Abi 
modifier_imba_death_prophet_spirit_siphon_buff = class({})

function modifier_imba_death_prophet_spirit_siphon_buff:IsDebuff()			return false end
function modifier_imba_death_prophet_spirit_siphon_buff:IsHidden() 			return false end
function modifier_imba_death_prophet_spirit_siphon_buff:IsPurgable() 		return false end
function modifier_imba_death_prophet_spirit_siphon_buff:IsPurgeException() 	return false end
--function modifier_imba_death_prophet_spirit_siphon_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_death_prophet_spirit_siphon_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_death_prophet_spirit_siphon_buff:GetModifierMoveSpeedBonus_Constant() return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("movement_steal") end
function modifier_imba_death_prophet_spirit_siphon_buff:GetModifierPhysicalArmorBonus()
	if self:GetCaster():Has_Aghanims_Shard() then 
		return self:GetStackCount() * 1
	end

	return 0 
end

modifier_imba_death_prophet_spirit_siphon_debuff = class({})

function modifier_imba_death_prophet_spirit_siphon_debuff:IsDebuff()			return true end
function modifier_imba_death_prophet_spirit_siphon_debuff:IsHidden() 			return false end
function modifier_imba_death_prophet_spirit_siphon_debuff:IsPurgable() 			return false end
function modifier_imba_death_prophet_spirit_siphon_debuff:IsPurgeException() 	return false end
--function modifier_imba_death_prophet_spirit_siphon_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_death_prophet_spirit_siphon_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_death_prophet_spirit_siphon_debuff:GetModifierMoveSpeedBonus_Constant() return 0 - self:GetStackCount()*self:GetAbility():GetSpecialValueFor("movement_steal") end
function modifier_imba_death_prophet_spirit_siphon_debuff:GetModifierPhysicalArmorBonus()
	if self:GetCaster():Has_Aghanims_Shard() then 
		return 0 - self:GetStackCount() * 1
	end
	return 0 
end