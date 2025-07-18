-- Author: MouJiaoZi 01/08/2018
-- Arrangement: MysticBug 02/01/2021

--------------------------------------------------------------
--		    		 IMBA_NYX_ASSASSIN_IMPALE               --
--------------------------------------------------------------
CreateTalents("npc_dota_hero_nyx_assassin", "mb/hero_nyx_assassin")


imba_nyx_assassin_impale = class({})

LinkLuaModifier("modifier_impale_motion", "mb/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_impale_dmg_aura", "mb/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_impale_dmg_target", "mb/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_impale_dmg_counter", "mb/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_nyx_assassin_impale:IsHiddenWhenStolen() 		return false end
function imba_nyx_assassin_impale:IsRefreshable() 			return true end
function imba_nyx_assassin_impale:IsStealable() 			return true end
function imba_nyx_assassin_impale:IsNetherWardStealable()	return true end
function imba_nyx_assassin_impale:GetCastRange() return self:GetSpecialValueFor("length") end
function imba_nyx_assassin_impale:GetIntrinsicModifierName() return "modifier_impale_dmg_aura" end

function imba_nyx_assassin_impale:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local pos = target and target:GetAbsOrigin() or self:GetCursorPosition()
	local start_pos = caster:GetAbsOrigin()
	local direction=start_pos==pos and  TG_Direction(pos+Vector(1,1,0),start_pos) or TG_Direction(pos,start_pos)
	-- local direction = (pos - start_pos):Normalized()
	direction.z = 0.0
	local end_pos = start_pos + direction * (self:GetCastRange(pos, caster) + caster:GetCastRangeBonus())
	local marker = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 20.0}, start_pos, caster:GetTeamNumber(), false):entindex()
	EntIndexToHScript(marker).hitted = {}
	caster:EmitSound("Hero_NyxAssassin.Impale")
	local info = 
	{
		Ability = self,
		EffectName = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_impale.vpcf",
		vSpawnOrigin = start_pos,
		fDistance = (start_pos - end_pos):Length2D(),
		fStartRadius = self:GetSpecialValueFor("width"),
		fEndRadius = self:GetSpecialValueFor("width"),
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity = direction * self:GetSpecialValueFor("speed"),
		bProvidesVision = false,
		ExtraData = {marker = marker}
	}
	ProjectileManager:CreateLinearProjectile(info)
end

function imba_nyx_assassin_impale:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		EntIndexToHScript(keys.marker).hitted = nil
		EntIndexToHScript(keys.marker):ForceKill(false)
		return true
	end
	if not IsInTable(target, EntIndexToHScript(keys.marker).hitted) then
		target:EmitSound("Hero_NyxAssassin.Impale.Target")
		target:AddNewModifier(self:GetCaster(), self, "modifier_impale_motion", {duration = self:GetSpecialValueFor("air_time")})
		EntIndexToHScript(keys.marker).hitted[#EntIndexToHScript(keys.marker).hitted + 1] = target
		target:AddNewModifier_RS(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("duration") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_nyx_assassin_1")})
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_impale_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, GetGroundPosition(target:GetAbsOrigin(), nil))
		ParticleManager:ReleaseParticleIndex(pfx)
		local dmg = 0
		for _, buff in pairs(target:FindAllModifiersByName("modifier_impale_dmg_counter")) do
			dmg = dmg + buff:GetStackCount() * (self:GetSpecialValueFor("damage_repeat") / 100)
		end
		local damageTable = {
							victim = target,
							attacker = self:GetCaster(),
							damage = self:GetSpecialValueFor("damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_nyx_assassin_3"),
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}
		ApplyDamage(damageTable)
		local damageTable2 = {
							victim = target,
							attacker = self:GetCaster(),
							damage = dmg,
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
							ability = self, --Optional.
							}
		local dmg_done =  ApplyDamage(damageTable2)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, dmg_done, nil)
	end
end

modifier_impale_motion = class({})

function modifier_impale_motion:IsDebuff()				return true end
function modifier_impale_motion:IsHidden() 				return true end
function modifier_impale_motion:IsPurgable() 			return false end
function modifier_impale_motion:IsPurgeException() 		return true end
function modifier_impale_motion:IsStunDebuff() 			return true end
function modifier_impale_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_impale_motion:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_impale_motion:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_impale_motion:IsMotionController() return true end
function modifier_impale_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_impale_motion:OnCreated()
	if self:GetAbility() == nil then return end
	if IsServer() then
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			if self:GetParent():GetName() ~= "npc_dota_thinker" then
				self:Destroy()
			end
		end
	end
end

function modifier_impale_motion:OnIntervalThink()
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = self:GetAbility():GetSpecialValueFor("knock_up_height")
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)
end

function modifier_impale_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		if self:GetParent():GetName() ~= "npc_dota_thinker" then
			self:GetParent():EmitSound("Hero_NyxAssassin.Impale.TargetLand")
		end
		if self.hitted then
			self.hitted = nil
		end
	end
end

modifier_impale_dmg_aura = class({})

function modifier_impale_dmg_aura:IsHidden() return true end
function modifier_impale_dmg_aura:AllowIllusionDuplicate() return false end
function modifier_impale_dmg_aura:IsAura() return true end
function modifier_impale_dmg_aura:IsAuraActiveOnDeath() return true end
function modifier_impale_dmg_aura:GetAuraDuration() return 0.1 end
function modifier_impale_dmg_aura:GetModifierAura() return "modifier_impale_dmg_target" end
function modifier_impale_dmg_aura:GetAuraRadius() return 50000 end
function modifier_impale_dmg_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_impale_dmg_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_impale_dmg_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end

modifier_impale_dmg_counter = class({})

function modifier_impale_dmg_counter:IsDebuff()			return false end
function modifier_impale_dmg_counter:IsHidden() 		return true end
function modifier_impale_dmg_counter:IsPurgable() 		return false end
function modifier_impale_dmg_counter:IsPurgeException() return false end
function modifier_impale_dmg_counter:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

modifier_impale_dmg_target = class({})

function modifier_impale_dmg_target:IsDebuff()			return false end
function modifier_impale_dmg_target:IsHidden() 			return true end
function modifier_impale_dmg_target:IsPurgable() 		return false end
function modifier_impale_dmg_target:IsPurgeException() 	return false end
function modifier_impale_dmg_target:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_impale_dmg_target:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() or not self:GetParent():IsAlive() then
		return
	end
	local dmg = math.floor(keys.damage + 0.5)
	local buff = keys.unit:AddNewModifier(keys.unit, self:GetAbility(), "modifier_impale_dmg_counter", {duration = self:GetAbility():GetSpecialValueFor("damage_duration")})
	buff:SetStackCount(dmg)
end

--------------------------------------------------------------
--		    	  IMBA_NYX_ASSASSIN_MANA_BURN               --
--------------------------------------------------------------
imba_nyx_assassin_mana_burn = class({})

function imba_nyx_assassin_mana_burn:IsHiddenWhenStolen() 		return false end
function imba_nyx_assassin_mana_burn:IsRefreshable() 			return true end
function imba_nyx_assassin_mana_burn:IsStealable() 				return true end
function imba_nyx_assassin_mana_burn:IsNetherWardStealable()	return true end

function imba_nyx_assassin_mana_burn:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_NyxAssassin.ManaBurn.Cast")
	local target = self:GetCursorTarget()
	if target:TG_TriggerSpellAbsorb(self) then
		return
	end
	local mana = target:GetMana()
	local attr = (target:GetAgility() > target:GetStrength() and target:GetAgility() or target:GetStrength()) > target:GetIntellect(false) and (target:GetAgility() > target:GetStrength() and target:GetAgility() or target:GetStrength()) or target:GetIntellect(false)
	local mana_toburn = math.floor(attr * self:GetSpecialValueFor("float_multiplier") > mana and mana or attr * self:GetSpecialValueFor("float_multiplier"))
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAttachmentOrigin(target:ScriptLookupAttachment("attach_hitloc")))
	ParticleManager:SetParticleControl(pfx, 1, Vector(1, tostring(mana_toburn), 0))
	ParticleManager:SetParticleControl(pfx, 2, Vector(2, (#tostring(mana_toburn)) + 1, 0))
	ParticleManager:ReleaseParticleIndex(pfx)
	local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:ReleaseParticleIndex(pfx2)
	target:SetMana(target:GetMana() - mana_toburn)
	local damageTable = {
						victim = target,
						attacker = self:GetCaster(),
						damage = mana_toburn,
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
						ability = self, --Optional.
						}
	ApplyDamage(damageTable)
	target:EmitSound("Hero_NyxAssassin.ManaBurn.Target")
	--IMBA2 Burn Extra Target
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("burn_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= target then 
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			--enemy:EmitSound("Hero_NyxAssassin.ManaBurn.Target")
		end
	end
end

--------------------------------------------------------------
--		    IMBA_NYX_ASSASSIN_SPIKED_CARAPACE               --
--------------------------------------------------------------

imba_nyx_assassin_spiked_carapace = class({})

LinkLuaModifier("modifier_imba_spiked_carapace", "mb/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spiked_carapace_stun", "mb/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_nyx_assassin_spiked_carapace:IsHiddenWhenStolen() 	return false end
function imba_nyx_assassin_spiked_carapace:IsRefreshable() 			return true end
function imba_nyx_assassin_spiked_carapace:IsStealable() 			return true end
function imba_nyx_assassin_spiked_carapace:IsNetherWardStealable()	return true end
function imba_nyx_assassin_spiked_carapace:GetCastRange() return self:GetSpecialValueFor("burrow_stun_range") - self:GetCaster():GetCastRangeBonus() end

function imba_nyx_assassin_spiked_carapace:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_NyxAssassin.SpikedCarapace")
	caster:AddNewModifier(caster, self, "modifier_imba_spiked_carapace", {duration = self:GetSpecialValueFor("reflect_duration")})
	if caster:HasModifier("modifier_imba_burrow") then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("burrow_stun_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier_RS(caster, self, "modifier_imba_spiked_carapace_stun", {duration = self:GetSpecialValueFor("stun_duration")})
			enemy:EmitSound("Hero_NyxAssassin.SpikedCarapace.Stun")
		end
	end
end

modifier_imba_spiked_carapace = class({})

function modifier_imba_spiked_carapace:IsDebuff()			return false end
function modifier_imba_spiked_carapace:IsHidden() 			return false end
function modifier_imba_spiked_carapace:IsPurgable() 		return false end
function modifier_imba_spiked_carapace:IsPurgeException() 	return false end
function modifier_imba_spiked_carapace:GetEffectName() return "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace.vpcf" end
function modifier_imba_spiked_carapace:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_spiked_carapace:DeclareFunctions() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end

function modifier_imba_spiked_carapace:GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
	end
	if keys.attacker:IsMagicImmune() or keys.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() or keys.attacker:IsBuilding() then
		return -300
	end
	local dmg = keys.damage + self:GetCaster():TG_GetTalentValue("special_bonus_imba_nyx_assassin_2")*keys.damage/100
	if not self.hitted[keys.attacker:entindex()] then
		keys.attacker:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_imba_spiked_carapace_stun", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
		self.hitted[keys.attacker:entindex()] = true
	end
	local damageTable = {
						victim = keys.attacker,
						attacker = self:GetParent(),
						damage = dmg,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
						ability = self:GetAbility(), --Optional.
						}
	ApplyDamage(damageTable)
	keys.attacker:EmitSound("Hero_NyxAssassin.SpikedCarapace.Stun")
	return -300
end

function modifier_imba_spiked_carapace:OnCreated() self.hitted = {} end

function modifier_imba_spiked_carapace:OnDestroy() self.hitted = nil end

modifier_imba_spiked_carapace_stun = class({})

function modifier_imba_spiked_carapace_stun:IsDebuff()			return true end
function modifier_imba_spiked_carapace_stun:IsHidden() 			return false end
function modifier_imba_spiked_carapace_stun:IsPurgable() 		return false end
function modifier_imba_spiked_carapace_stun:IsPurgeException() 	return true end
function modifier_imba_spiked_carapace_stun:IsStunDebuff() 		return true end
function modifier_imba_spiked_carapace_stun:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_imba_spiked_carapace_stun:GetEffectAttachType() return  PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_spiked_carapace_stun:ShouldUseOverheadOffset() return true end
function modifier_imba_spiked_carapace_stun:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_imba_spiked_carapace_stun:DeclareFunctions() return ({MODIFIER_PROPERTY_OVERRIDE_ANIMATION}) end
function modifier_imba_spiked_carapace_stun:GetOverrideAnimation() return ACT_DOTA_DISABLED end
function modifier_imba_spiked_carapace_stun:OnCreated()
	if self:GetAbility() == nil then return end
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetDuration(), 0, 0))
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end

--------------------------------------------------------------
--	 		     IMBA_NYX_ASSASSIN_BURROW   	            --
--------------------------------------------------------------
imba_nyx_assassin_burrow = class({})

LinkLuaModifier("modifier_imba_burrow", "mb/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_nyx_assassin_burrow:IsHiddenWhenStolen() 		return false end
function imba_nyx_assassin_burrow:IsRefreshable() 			return true end
function imba_nyx_assassin_burrow:IsStealable() 			return false end
function imba_nyx_assassin_burrow:IsNetherWardStealable()	return false end
function imba_nyx_assassin_burrow:GetAssociatedSecondaryAbilities() return "imba_nyx_assassin_unburrow" end

function imba_nyx_assassin_burrow:OnAbilityPhaseStart()
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	self.pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_inground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	self:GetCaster():EmitSound("Hero_NyxAssassin.Burrow.In")
	return true
end

function imba_nyx_assassin_burrow:OnAbilityPhaseInterrupted()
	ParticleManager:DestroyParticle(self.pfx, true)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	ParticleManager:DestroyParticle(self.pfx2, true)
	ParticleManager:ReleaseParticleIndex(self.pfx2)
end

function imba_nyx_assassin_burrow:OnSpellStart()
	local caster = self:GetCaster()
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	local burrow = "imba_nyx_assassin_burrow"
	local unburrow = "imba_nyx_assassin_unburrow"
	local burrow_ability = caster:FindAbilityByName(burrow)
	local unburrow_ability = caster:FindAbilityByName(unburrow)
	caster:SwapAbilities(burrow, unburrow, false, true)
	unburrow_ability:SetLevel(1)
	burrow_ability:SetHidden(true)
	burrow_ability:SetLevel(0)
end

--------------------------------------------------------------
--	 		     IMBA_NYX_ASSASSIN_UNBURROW   	            --
--------------------------------------------------------------
imba_nyx_assassin_unburrow = class({})

function imba_nyx_assassin_unburrow:IsHiddenWhenStolen() 	return true end
function imba_nyx_assassin_unburrow:IsRefreshable() 		return true end
function imba_nyx_assassin_unburrow:IsStealable() 			return false end
function imba_nyx_assassin_unburrow:IsNetherWardStealable()	return false end
function imba_nyx_assassin_unburrow:GetAssociatedPrimaryAbilities() return "imba_nyx_assassin_burrow" end
function imba_nyx_assassin_unburrow:GetIntrinsicModifierName() return "modifier_imba_burrow" end

function imba_nyx_assassin_unburrow:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_NyxAssassin.Burrow.Out")
	local burrow = "imba_nyx_assassin_burrow"
	local unburrow = "imba_nyx_assassin_unburrow"
	local burrow_ability = caster:FindAbilityByName(burrow)
	local unburrow_ability = caster:FindAbilityByName(unburrow)
	caster:SwapAbilities(burrow, unburrow, true, false)
	burrow_ability:SetLevel(1)
	unburrow_ability:SetHidden(true)
	unburrow_ability:SetLevel(0)
	caster:FindModifierByName("modifier_imba_burrow"):Destroy()
	caster:StartGesture(ACT_DOTA_CAST_BURROW_END)
	ParticleManager:DestroyParticle(burrow_ability.pfx2, true)
	ParticleManager:ReleaseParticleIndex(burrow_ability.pfx2)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_exit.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(pfx)
end

modifier_imba_burrow = class({})

function modifier_imba_burrow:IsDebuff()			return false end
function modifier_imba_burrow:IsHidden() 			return false end
function modifier_imba_burrow:IsPurgable() 			return false end
function modifier_imba_burrow:IsPurgeException() 	return false end
function modifier_imba_burrow:GetTexture() return "nyx_assassin_burrow" end
function modifier_imba_burrow:CheckState() return {[MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_INVISIBLE] = true} end
function modifier_imba_burrow:DeclareFunctions() return {MODIFIER_PROPERTY_MODEL_CHANGE, MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING} end
function modifier_imba_burrow:GetModifierModelChange() return "models/heroes/nerubian_assassin/mound.vmdl" end
function modifier_imba_burrow:GetModifierHealthRegenPercentage() return self:GetAbility():GetSpecialValueFor("health_regen_rate") end
function modifier_imba_burrow:GetModifierTotalPercentageManaRegen() return self:GetAbility():GetSpecialValueFor("mana_regen_rate") end
function modifier_imba_burrow:GetModifierIncomingDamage_Percentage()
	if not self:GetParent():HasModifier("modifier_imba_rapier_super_unique") then
		return (0 - self:GetAbility():GetSpecialValueFor("damage_reduction"))
	else
		return 0
	end
end

function modifier_imba_burrow:GetModifierCastRangeBonusStacking() return self:GetAbility():GetSpecialValueFor("cast_range_bonus") end

function modifier_imba_burrow:OnCreated()
	if self:GetAbility() == nil then return end
	if IsServer() and self:GetParent():IsIllusion() then
		self:Destroy()
	end
end

--------------------------------------------------------------
--	 		     IMBA_NYX_ASSASSIN_VENDETTA   	            --
--------------------------------------------------------------
imba_nyx_assassin_vendetta = class({})

LinkLuaModifier("modifier_imba_vendetta", "mb/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_vendetta_damage_stacks", "mb/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_vendetta_flag", "mb/hero_nyx_assassin", LUA_MODIFIER_MOTION_NONE)
function imba_nyx_assassin_vendetta:IsHiddenWhenStolen() 	return false end
function imba_nyx_assassin_vendetta:IsRefreshable() 		return true end
function imba_nyx_assassin_vendetta:IsStealable() 			return true end
function imba_nyx_assassin_vendetta:IsNetherWardStealable()	return true end
function imba_nyx_assassin_vendetta:GetIntrinsicModifierName() return "modifier_imba_vendetta_damage_stacks" end

function imba_nyx_assassin_vendetta:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_NyxAssassin.Vendetta")
	if caster:HasModifier("modifier_imba_burrow") then
		caster:FindAbilityByName("imba_nyx_assassin_unburrow"):OnSpellStart()
	end
	caster:AddNewModifier(caster, self, "modifier_imba_vendetta", {duration = self:GetSpecialValueFor("duration")})
end


modifier_imba_vendetta = class({})

function modifier_imba_vendetta:IsDebuff()			return false end
function modifier_imba_vendetta:IsHidden() 			return false end
function modifier_imba_vendetta:IsPurgable() 		return false end
function modifier_imba_vendetta:IsPurgeException() 	return false end
function modifier_imba_vendetta:OnCreated(keys)
	if self:GetAbility() == nil then return end
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.movement_speed = self:GetAbility():GetSpecialValueFor("movement_speed")
	self.break_duration = self:GetAbility():GetSpecialValueFor("break_duration")
	self.shard_movement_speed = self:GetAbility():GetSpecialValueFor("shard_movement_speed")
end
function modifier_imba_vendetta:OnDestroy(keys)
	self.bonus_damage = nil
	self.movement_speed = nil 
	self.break_duration = nil 
	self.shard_movement_speed = nil
end

function modifier_imba_vendetta:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	if self:GetCaster():TG_HasTalent("special_bonus_imba_nyx_assassin_4") then 
		state = {
			[MODIFIER_STATE_INVISIBLE] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_ALLOW_PATHING_THROUGH_CLIFFS] = true
		}
	end
	return state
end

function modifier_imba_vendetta:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_DISABLE_AUTOATTACK, MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ABILITY_EXECUTED, MODIFIER_PROPERTY_INVISIBILITY_LEVEL, MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,}
end

function modifier_imba_vendetta:GetModifierPreAttack_BonusDamage(keys)
	if self:GetParent() == keys.attacker then
		 if keys.target:HasModifier("modifier_backdoor_protection") or keys.target:HasModifier("modifier_backdoor_protection_active") then
		 	return 0 
		 end
		 return (self.bonus_damage + self:GetParent():GetModifierStackCount("modifier_imba_vendetta_damage_stacks", self:GetParent()) * 10)	
	end
end 

function modifier_imba_vendetta:GetModifierMoveSpeedBonus_Percentage() return (self:GetCaster():Has_Aghanims_Shard() and self.shard_movement_speed + self.movement_speed) or self.movement_speed end

function modifier_imba_vendetta:GetModifierIgnoreMovespeedLimit()  return self:GetCaster():Has_Aghanims_Shard() and 1 or 0 end

function modifier_imba_vendetta:GetDisableAutoAttack() return true end

function modifier_imba_vendetta:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and self:GetParent():IsRangedAttacker() then
		if target:IsBuilding() then
			--计算一次攻击，但是这次攻击不计算复仇的额外伤害，同时也不消耗复仇攻击.
			self:Destroy()
			return		 
		end
		local buff = self:GetParent():FindModifierByName("modifier_imba_vendetta_damage_stacks")
		if buff then 
			buff:SetStackCount(0)
		end
		self:Destroy()
	end
end

function modifier_imba_vendetta:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and not self:GetParent():IsRangedAttacker() then
		if keys.target:HasModifier("modifier_backdoor_protection") or keys.target:HasModifier("modifier_backdoor_protection_active") then
			--计算一次攻击，但是这次攻击不计算复仇的额外伤害，同时也不消耗复仇攻击.
			self:Destroy()
			return		 
		end
		local buff = self:GetParent():FindModifierByName("modifier_imba_vendetta_damage_stacks")
		if buff then 
			if keys.target:HasModifier("modifier_imba_vendetta_flag") then
				TG_Kill(keys.attacker, keys.target, self:GetAbility())
				keys.target:RemoveModifierByName("modifier_imba_vendetta_flag")
			end
			buff:SetStackCount(0)
		end
		--add breaker Effect
		if not keys.target:IsBuilding() or not keys.target:IsOther() then 
			keys.target:AddNewModifier_RS(self:GetParent(),self:GetAbility(),"modifier_nyx_assassin_vendetta_break",{duration = self.break_duration})
			--modifier_nyx_assassin_vendetta_armor_reduction
			if self:GetCaster():Has_Aghanims_Shard() then 
				keys.target:AddNewModifier_RS(self:GetParent(),self:GetAbility(),"modifier_nyx_assassin_vendetta_armor_reduction",{duration = self.break_duration})
			end	
		end
		self:Destroy()
	end
end

function modifier_imba_vendetta:OnAbilityExecuted(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() or keys.ability:GetName() == "imba_nyx_assassin_spiked_carapace" then
		return
	end
	self:Destroy()
end

function modifier_imba_vendetta:GetModifierInvisibilityLevel() return 1 end

modifier_imba_vendetta_damage_stacks = class({})

function modifier_imba_vendetta_damage_stacks:IsDebuff()			return false end
function modifier_imba_vendetta_damage_stacks:AllowIllusionDuplicate()		return false end
function modifier_imba_vendetta_damage_stacks:IsHidden() 			return false end
function modifier_imba_vendetta_damage_stacks:IsPurgable() 			return false end
function modifier_imba_vendetta_damage_stacks:IsPurgeException() 	return false end
function modifier_imba_vendetta_damage_stacks:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH,MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_TOOLTIP,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
function modifier_imba_vendetta_damage_stacks:OnTooltip() return (10 * self:GetStackCount()) end
function modifier_imba_vendetta_damage_stacks:OnDeath(tg)
	if IsServer() then
        if tg.unit == self:GetParent() then 
			tg.attacker:AddNewModifier(tg.unit,self:GetAbility(),"modifier_imba_vendetta_flag",{duration = -1})
		end
    end
end

function modifier_imba_vendetta_damage_stacks:GetModifierIncomingDamage_Percentage(keys)
	if IsServer() then
		--泉水不在增加叠伤
		if  bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if keys.attacker:GetName() == "ent_dota_fountain_bad" or keys.attacker:GetName() == "ent_dota_fountain_good" then
			return 0 
		end
		local stacks = math.floor(keys.damage / 10)
		local max_stacks = self:GetAbility():GetSpecialValueFor("damage_storage") / 10
		if self:GetParent():HasScepter() then
			max_stacks = 99999999
		end
		self:SetStackCount(math.min(self:GetStackCount()+stacks, max_stacks))
		return 0
	end
end

function modifier_imba_vendetta_damage_stacks:OnCreated()
	if self:GetAbility() == nil then return end
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_vendetta_damage_stacks:OnIntervalThink()
	local caster = self:GetCaster()
	local burrow = "imba_nyx_assassin_burrow"
	local unburrow = "imba_nyx_assassin_unburrow"
	local burrow_ability = caster:FindAbilityByName(burrow)
	local unburrow_ability = caster:FindAbilityByName(unburrow)
	if not burrow_ability or not unburrow_ability then
		return
	end
	if caster:HasScepter() and burrow_ability:GetLevel() == 0 and unburrow_ability:GetLevel() == 0 then
		burrow_ability:SetHidden(false)
		burrow_ability:SetLevel(1)
	end
	if not caster:HasScepter() and burrow_ability:GetLevel() == 1 and unburrow_ability:GetLevel() == 0 then
		burrow_ability:SetHidden(true)
		burrow_ability:SetLevel(0)
	end
	if not caster:HasScepter() and unburrow_ability:GetLevel() == 1 and burrow_ability:GetLevel() == 0 then
		unburrow_ability:OnSpellStart()
		unburrow_ability:SetHidden(true)
		unburrow_ability:SetLevel(0)
		burrow_ability:SetHidden(true)
		burrow_ability:SetLevel(0)
		caster:FindModifierByName("modifier_imba_burrow"):Destroy()
		caster:StartGesture(ACT_DOTA_CAST_BURROW_END)
		ParticleManager:DestroyParticle(burrow_ability.pfx2, true)
		ParticleManager:ReleaseParticleIndex(burrow_ability.pfx2)
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_exit.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
end

function modifier_imba_vendetta_damage_stacks:GetModifierPreAttack_BonusDamage(keys) 
	if IsServer() then
			if self:GetParent() == keys.attacker  and not self:GetParent():IsIllusion() and not self:GetParent():HasModifier("modifier_imba_vendetta") then 
				local damage_max = self:GetAbility():GetSpecialValueFor("bouns_damage_max") 
				local damage_preattack = self:GetStackCount()*10*self:GetAbility():GetSpecialValueFor("bouns_damage_pct")/100
				return damage_preattack > damage_max and damage_max or damage_preattack
			end
	end
end

modifier_imba_vendetta_flag = class({})

function modifier_imba_vendetta_flag:IsDebuff()			return true end
function modifier_imba_vendetta_flag:AllowIllusionDuplicate()		return false end
function modifier_imba_vendetta_flag:IsHidden() 			return true end
function modifier_imba_vendetta_flag:IsPurgable() 			return false end
function modifier_imba_vendetta_flag:IsPurgeException() 	return false end
function modifier_imba_vendetta_flag:RemoveOnDeath() 		return false end
function modifier_imba_vendetta_flag:OnCreated() 		
	if IsServer() then
	local pfx_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_mark_overhead_lv.vpcf"
	self.pfx = ParticleManager:CreateParticleForPlayer(pfx_name, PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetPlayerOwner())
	self:AddParticle(self.pfx, false, false, 15, false, false)
	end
end
function modifier_imba_vendetta_flag:OnRemoved()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end			
	end
end