CreateTalents("npc_dota_hero_bounty_hunter", "heros/hero_bounty_hunter/hero_bounty_hunter.lua")

imba_bounty_hunter_shuriken_toss = class({})

LinkLuaModifier("modifier_imba_shuriken_toss_chain", "heros/hero_bounty_hunter/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shuriken_toss_flag", "heros/hero_bounty_hunter/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)


function imba_bounty_hunter_shuriken_toss:IsHiddenWhenStolen() 		return false end
function imba_bounty_hunter_shuriken_toss:IsRefreshable() 			return true  end
function imba_bounty_hunter_shuriken_toss:IsStealable() 			return true  end
function imba_bounty_hunter_shuriken_toss:GetCastRange(target)
	return self:GetSpecialValueFor("range")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_bounty_hunter_2")
end

function imba_bounty_hunter_shuriken_toss:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local sp =self:GetSpecialValueFor("speed")
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_BountyHunter.Shuriken", caster)
	local info =
	{
		Target = target,
		Source = caster,
		Ability = self,
		EffectName = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf",
		iMoveSpeed = sp*5,
		vSourceLoc= caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), Vector(0,0,0), nil, 250000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_UNITS_EVERYWHERE, false)
	for _, enemy in pairs(enemies) do
		if enemy:HasModifier("modifier_imba_track") and enemy ~= target then
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_BountyHunter.Shuriken", caster)
			local info =
			{
				Target = enemy,
				Source = caster,
				Ability = self,
				EffectName = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf",
				iMoveSpeed = sp/2,
				vSourceLoc= caster:GetAbsOrigin(),
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 30,
				bProvidesVision = false,
			}
			ProjectileManager:CreateTrackingProjectile(info)
		end
	end
end

function imba_bounty_hunter_shuriken_toss:OnProjectileHit(hTarget, vLocation)
	if not hTarget or not self then
		return
	end
	if hTarget:TG_TriggerSpellAbsorb(self) then
		return
	end
	local ability = self:GetCaster():FindAbilityByName("imba_bounty_hunter_jinada")
	local ability2 = self:GetCaster():FindAbilityByName("imba_bounty_hunter_track")
	local damage = self:GetSpecialValueFor("damage")
	local caster = self:GetCaster()
	local target = hTarget
	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_BountyHunter.Shuriken.Impact", hTarget)
	if caster:TG_HasTalent("special_bonus_imba_bounty_hunter_1") and ability and ability:GetLevel() > 0 then
		if ability:IsCooldownReady() then
			if self:GetAutoCastState() then
				damage = damage*ability:GetSpecialValueFor("crit_damage")*0.01
				local steal = damage*(1+math.abs(caster:GetSpellAmplification(false)))*0.1 + ability:GetSpecialValueFor("gold_steal")
				target:EmitSound("Hero_BountyHunter.Jinada")
				target:AddNewModifier(caster, ability, "modifier_imba_jinada_slow", {duration = ability:GetSpecialValueFor("slow_duration")})
				local pfx = ParticleManager:CreateParticle("particles/econ/items/bounty_hunter/bounty_hunter_ti9_immortal/bh_ti9_immortal_jinada.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hTarget)
				ParticleManager:SetParticleControl(pfx,0,Vector(100,0,0))
				ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(pfx)
				PlayerResource:ModifyGold(target:GetPlayerOwnerID(), (0 - steal), false, DOTA_ModifyGold_Unspecified)
				PopupNumbers(target, "gold", Vector(255, 200, 33), 1.0,(0 -steal), 1)
				PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), steal, true, DOTA_ModifyGold_Unspecified)
				PopupNumbers(caster, "gold", Vector(255, 200, 33), 1.0, steal, 0)
				ability:UseResources(true,  false,true, true)
				if ability2 and ability2:GetLevel() > 0 and caster:TG_HasTalent("special_bonus_imba_bounty_hunter_3")then
					local buff = target:AddNewModifier(caster, ability2, "modifier_imba_track", {duration = caster:TG_GetTalentValue("special_bonus_imba_bounty_hunter_3")})
					if caster:HasScepter() then
						buff:SetStackCount(1)
					end
				end
			else
				caster:AddNewModifier(caster,self,"modifier_imba_shuriken_toss_flag",{duration = 1})
				caster:PerformAttack(hTarget, true, true, true, false, false, false, true)
				caster:RemoveModifierByName("modifier_imba_shuriken_toss_flag")
			end
		end
	end
	
	local damageTable = {
						victim = target,
						attacker = caster,
						damage = damage,
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self, --Optional.
						}
						
	ApplyDamage(damageTable)
	target:AddNewModifier(caster, self, "modifier_imba_stunned", {duration = self:GetSpecialValueFor("mini_stun")})
	target:AddNewModifier(caster, self, "modifier_imba_shuriken_toss_chain", {duration = self:GetSpecialValueFor("chain_duration")})
	return true
end

modifier_imba_shuriken_toss_flag = class({})

function modifier_imba_shuriken_toss_flag:IsHidden()			return true end
function modifier_imba_shuriken_toss_flag:IsDebuff()			return false end
function modifier_imba_shuriken_toss_flag:IsPurgable() 		return false end
function modifier_imba_shuriken_toss_flag:IsPurgeException() 	return false end


modifier_imba_shuriken_toss_chain = class({})

function modifier_imba_shuriken_toss_chain:IsDebuff()			return true end
function modifier_imba_shuriken_toss_chain:IsHidden() 			return false end
function modifier_imba_shuriken_toss_chain:IsPurgable() 		return false end
function modifier_imba_shuriken_toss_chain:IsPurgeException() 	return false end
function modifier_imba_shuriken_toss_chain:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_shuriken_toss_chain:OnCreated()
	if self:GetAbility() == nil then return end
	if not IsServer() then
		return
	end
	local target_position = self:GetParent():GetAbsOrigin()

	self.dummy = CreateUnitByName("npc_dummy_unit", target_position, false, nil, nil, self:GetCaster():GetTeamNumber())
	self.dummy:SetOrigin(target_position)
	self.dummy:AddNewModifier(self.dummy, nil, "modifier_kill", {duration = self:GetDuration() + 1.0})
	self.dummy:AddNewModifier(self.dummy, nil, "modifier_unit_remove", {duration = self:GetDuration() + 1.0})
	local pfx = ParticleManager:CreateParticle("particles/econ/items/pudge/pudge_trapper_beam_chain/pudge_nx_meathook_chain.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(pfx, 6, self.dummy, PATTACH_POINT_FOLLOW, "attach_hitloc", target_position, false)
	ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", target_position, false)
	self:AddParticle(pfx, true, false, 15, false, false)
	self:StartIntervalThink(0.1)
end

function modifier_imba_shuriken_toss_chain:OnIntervalThink()
	if self:GetAbility() == nil then return end
	local caster = self:GetCaster()
	local target = self:GetParent()
	local ability = self:GetAbility()
	local chain_range = ability:GetSpecialValueFor("chain_range")
	local pull_strength = ability:GetSpecialValueFor("pull_strength_tooltip")

	-- Retrieve the target's distance from the impact point
	local target_position = target:GetAbsOrigin()
	local center_vector = self.dummy:GetAbsOrigin() - target_position
	local len = center_vector:Length2D()
	local tick_rate = 0.05

	-- Push the target towards the impact point with a strength proportional to its distance from it
	local pull_distance = center_vector:Normalized() * len / chain_range * pull_strength * tick_rate
	FindClearSpaceForUnit(target, target_position + pull_distance, false)
end

function modifier_imba_shuriken_toss_chain:OnDestroy()
	if not IsServer() then
		return
	end
	self.dummy = nil
end

imba_bounty_hunter_jinada = class({})

LinkLuaModifier("modifier_imba_jinada_passive", "heros/hero_bounty_hunter/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_jinada_slow", "heros/hero_bounty_hunter/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)

function imba_bounty_hunter_jinada:GetIntrinsicModifierName() return "modifier_imba_jinada_passive" end

modifier_imba_jinada_passive = class({})

function modifier_imba_jinada_passive:IsHidden()			return false end
function modifier_imba_jinada_passive:IsDebuff()			return false end
function modifier_imba_jinada_passive:IsPurgable() 			return false end
function modifier_imba_jinada_passive:IsPurgeException() 	return false end
function modifier_imba_jinada_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE, MODIFIER_EVENT_ON_ATTACK_FAIL} end

function modifier_imba_jinada_passive:OnCreated() self.crit = {} end
function modifier_imba_jinada_passive:OnDestroy() self.crit = nil end

function modifier_imba_jinada_passive:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() and not self:GetParent():PassivesDisabled() then
		if self:GetAbility():IsCooldownReady() then
			self:GetAbility():UseResources(true,  false,true, true)
			self.crit[keys.record] = true
			return self:GetAbility():GetSpecialValueFor("crit_damage")
		end
	end
end

function modifier_imba_jinada_passive:OnAttackFail(keys) self.crit[keys.record] = nil end

function modifier_imba_jinada_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or keys.target:IsOther() or keys.target:IsBuilding() or not keys.target:IsAlive() or self:GetParent():IsIllusion() then
		return
	end
	local ab = self:GetAbility()
	local parent = self:GetParent()
	if self.crit[keys.record] then
		local damage = keys.damage*0.1
		if not keys.target:IsTrueHero() then
			damage = 10
		end
		keys.target:EmitSound("Hero_BountyHunter.Jinada")
		keys.target:AddNewModifier(parent, ab, "modifier_imba_jinada_slow", {duration = ab:GetSpecialValueFor("slow_duration")})
		local pfx = ParticleManager:CreateParticle("particles/econ/items/bounty_hunter/bounty_hunter_ti9_immortal/bh_ti9_immortal_jinada.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, keys.target)
		ParticleManager:SetParticleControl(pfx,0,Vector(100,0,0))
		ParticleManager:SetParticleControlEnt(pfx, 1, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		PlayerResource:ModifyGold(keys.target:GetPlayerOwnerID(), (0 - (ab:GetSpecialValueFor("gold_steal")+damage)), false, DOTA_ModifyGold_Unspecified)
		PopupNumbers(keys.target, "gold", Vector(255, 200, 33), 1.0, (ab:GetSpecialValueFor("gold_steal")+damage), 1)
		PlayerResource:ModifyGold(parent:GetPlayerOwnerID(), (ab:GetSpecialValueFor("gold_steal")+damage), true, DOTA_ModifyGold_Unspecified)
		PopupNumbers(parent, "gold", Vector(255, 200, 33), 1.0, (ab:GetSpecialValueFor("gold_steal")+damage), 0)
		local stack=self:GetStackCount()
		self:SetStackCount(stack+((ab:GetSpecialValueFor("gold_steal")+damage)))
		local ability = parent:FindAbilityByName("imba_bounty_hunter_track")
		if ability and ability:GetLevel() > 0 and parent:TG_HasTalent("special_bonus_imba_bounty_hunter_3") then
			local buff = keys.target:AddNewModifier(parent, ability, "modifier_imba_track", {duration = parent:TG_GetTalentValue("special_bonus_imba_bounty_hunter_3")})
			if parent:HasScepter() then
				buff:SetStackCount(1)
			end
		end	
	end
	
	if keys.target:IsTrueHero() then
		PlayerResource:ModifyGold(keys.target:GetPlayerOwnerID(), (0 - (ab:GetSpecialValueFor("gold_steal"))), false, DOTA_ModifyGold_Unspecified)
		PopupNumbers(keys.target, "gold", Vector(255, 200, 33), 1.0, (ab:GetSpecialValueFor("gold_steal")), 1)
		PlayerResource:ModifyGold(parent:GetPlayerOwnerID(), (ab:GetSpecialValueFor("gold_steal")), true, DOTA_ModifyGold_Unspecified)
		PopupNumbers(parent, "gold", Vector(255, 200, 33), 1.0, (ab:GetSpecialValueFor("gold_steal")), 0)
		local stack2=self:GetStackCount()
		self:SetStackCount(stack2+(ab:GetSpecialValueFor("gold_steal")))
	end

	self.crit[keys.record] = nil
end

modifier_imba_jinada_slow = class({})

function modifier_imba_jinada_slow:IsHidden()			return false end
function modifier_imba_jinada_slow:IsDebuff()			return true end
function modifier_imba_jinada_slow:IsPurgable() 		return true end
function modifier_imba_jinada_slow:IsPurgeException() 	return true end
function modifier_imba_jinada_slow:DeclareFunctions()	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_jinada_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("ms_slow")) end
function modifier_imba_jinada_slow:GetStatusEffectName() return "particles/units/heroes/hero_bounty_hunter/status_effect_bounty_hunter_jinda_slow.vpcf" end
function modifier_imba_jinada_slow:StatusEffectPriority() return 15 end

imba_bounty_hunter_wind_walk = class({})

LinkLuaModifier("modifier_imba_wind_walk_fade", "heros/hero_bounty_hunter/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wind_walk", "heros/hero_bounty_hunter/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)

function imba_bounty_hunter_wind_walk:IsHiddenWhenStolen() 		return false end
function imba_bounty_hunter_wind_walk:IsRefreshable() 			return true  end
function imba_bounty_hunter_wind_walk:IsStealable() 			return true  end


function imba_bounty_hunter_wind_walk:OnSpellStart()
	EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Hero_BountyHunter.WindWalk", self:GetCaster())
	local fade_time = self:GetCaster():TG_HasTalent("special_bonus_imba_bounty_hunter_6") and 0.01 or self:GetSpecialValueFor("fade_time")
	self:GetCaster():AddNewModifier(self:GetCaster() , self, "modifier_imba_wind_walk_fade", {duration = fade_time})
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(pfx)
end

modifier_imba_wind_walk_fade = class({})

function modifier_imba_wind_walk_fade:IsDebuff()			return false end
function modifier_imba_wind_walk_fade:IsHidden() 			return false end
function modifier_imba_wind_walk_fade:IsPurgable() 			return false end
function modifier_imba_wind_walk_fade:IsPurgeException() 	return false end

function modifier_imba_wind_walk_fade:OnDestroy()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_wind_walk", {duration = self:GetAbility():GetSpecialValueFor("duration")})
	end
end

modifier_imba_wind_walk = class({})

function modifier_imba_wind_walk:IsDebuff()				return false end
function modifier_imba_wind_walk:IsHidden() 			return false end
function modifier_imba_wind_walk:IsPurgable() 			return false end
function modifier_imba_wind_walk:IsPurgeException() 	return false end
function modifier_imba_wind_walk:GetEffectName() return "particles/generic_hero_status/status_invisibility_start.vpcf" end
function modifier_imba_wind_walk:GetEffectAttachType() return PATTACH_ABSORIGIN end

function modifier_imba_wind_walk:CheckState()
	return {[MODIFIER_STATE_INVISIBLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
end

function modifier_imba_wind_walk:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,MODIFIER_EVENT_ON_ATTACK, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_DISABLE_AUTOATTACK, MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ABILITY_EXECUTED, MODIFIER_PROPERTY_INVISIBILITY_LEVEL}
end

function modifier_imba_wind_walk:GetModifierPreAttack_BonusDamage() return self.damage end

function modifier_imba_wind_walk:GetModifierMoveSpeedBonus_Percentage() return self.move end

function modifier_imba_wind_walk:GetDisableAutoAttack() return true end
function modifier_imba_wind_walk:GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then return end
	return self.re 
end
function modifier_imba_wind_walk:OnCreated()
	if self:GetAbility() == nil then return end
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.move = self.ability:GetSpecialValueFor("move_speed")+self.parent:TG_GetTalentValue("special_bonus_imba_bounty_hunter_6")
	self.damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.re = self.parent:TG_GetTalentValue("special_bonus_imba_bounty_hunter_5")*-1
end
function modifier_imba_wind_walk:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and self:GetParent():IsRangedAttacker() then
		self:Destroy()
	end
end

function modifier_imba_wind_walk:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self.parent and not self:GetParent():IsRangedAttacker() then
		if self.parent:TG_HasTalent("special_bonus_imba_bounty_hunter_4") then
			keys.target:AddNewModifier(self.parent,self.ability,"modifier_imba_stunned",{duration = self.parent:TG_GetTalentValue("special_bonus_imba_bounty_hunter_4")})
		end
		if not keys.attacker:HasModifier("modifier_imba_shuriken_toss_flag") then
			self:Destroy()
		end
	end
end

function modifier_imba_wind_walk:OnAbilityExecuted(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	local ability = self:GetParent():FindAbilityByName("imba_bounty_hunter_track")
	local ability2 = self:GetParent():FindAbilityByName("imba_bounty_hunter_shadow_jaunt")
	local ability3 = self:GetParent():FindAbilityByName("imba_bounty_hunter_shuriken_toss")
	if keys.ability == ability or keys.ability == ability2 or keys.ability == ability3 then
		return
	end
	self:Destroy()
end

function modifier_imba_wind_walk:GetModifierInvisibilityLevel() return 1 end

imba_bounty_hunter_shadow_jaunt = class({})

function imba_bounty_hunter_shadow_jaunt:IsHiddenWhenStolen() 		return false end
function imba_bounty_hunter_shadow_jaunt:IsRefreshable() 			return true  end
function imba_bounty_hunter_shadow_jaunt:IsStealable() 				return false  end


function imba_bounty_hunter_shadow_jaunt:CastFilterResultTarget(target)
	if target:IsInvulnerable() then
		return UF_FAIL_INVULNERABLE
	end
	if target == self:GetCaster() or not target:IsHero() then
		return UF_FAIL_CUSTOM
	end
end

function imba_bounty_hunter_shadow_jaunt:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	elseif not target:IsHero() then
		return "#dota_hud_error_cant_cast_on_other"
	end
end

function imba_bounty_hunter_shadow_jaunt:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	-- Blink geometry
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()
	local blink_direction = (target_pos - caster_pos):Normalized()
	blink_direction.z = 0.0
	target_pos = target_pos + blink_direction * 100
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(pfx)

	-- Blink
	FindClearSpaceForUnit(caster, target_pos, false)
	if caster:GetTeamNumber() ~= target:GetTeamNumber() then
		caster:SetForwardVector((target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized())
	else
		caster:SetForwardVector(blink_direction)
	end
	caster:SetAngles(0, 0, 0)
	local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(pfx2, 0, target_pos)
	ParticleManager:ReleaseParticleIndex(pfx2)

	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Riki.Blink_Strike", caster)

	-- If the target is tracked, refresh all abilities
	if target:HasModifier("modifier_imba_track") then
		-- Refresh all abilities
		local current_ability
		for i = 0, 23 do
			current_ability = caster:GetAbilityByIndex(i)
			if current_ability and self ~= current_ability and not Is_DATA_TG(NOT_RS_SK,current_ability:GetName()) then
				current_ability:EndCooldown()
				current_ability:RefreshCharges()
			end
		end
	end

	-- If the target is an enemy, start attacking it
	if caster:GetTeamNumber() ~= target:GetTeamNumber() then
		caster:SetAttacking(target)
		caster:SetForceAttackTarget(target)
		Timers:CreateTimer(0.01, function()
			caster:SetForceAttackTarget(nil)
		end)
	end
	caster:MoveToTargetToAttack(target)
end


imba_bounty_hunter_track = class({})

LinkLuaModifier("modifier_imba_track_cirt", "heros/hero_bounty_hunter/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_track", "heros/hero_bounty_hunter/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_track_aura", "heros/hero_bounty_hunter/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_track_speed", "heros/hero_bounty_hunter/hero_bounty_hunter", LUA_MODIFIER_MOTION_NONE)

function imba_bounty_hunter_track:IsHiddenWhenStolen() 		return false end
function imba_bounty_hunter_track:IsRefreshable() 			return true  end
function imba_bounty_hunter_track:IsStealable() 			return true  end
function imba_bounty_hunter_track:GetIntrinsicModifierName() return "modifier_imba_track_cirt" end

function imba_bounty_hunter_track:OnUpgrade()
	if self:GetLevel() >= 1 then
		local ability = self:GetCaster():FindAbilityByName("imba_bounty_hunter_shadow_jaunt")
		if ability then
			ability:SetLevel(1)
		end
	end
end

function imba_bounty_hunter_track:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TG_TriggerSpellAbsorb(self) then
		return
	end
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT, "attach_attack2", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, true)
			ParticleManager:ReleaseParticleIndex(pfx)
			return nil
		end
	)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_BountyHunter.Target", caster)
	local buff = target:AddNewModifier(caster, self, "modifier_imba_track", {duration = self:GetSpecialValueFor("duration")})
	--target:AddNewModifier(caster, self, "modifier_imba_track_aura", {duration = self:GetSpecialValueFor("duration")})
	if caster:HasScepter() then
		buff:SetStackCount(1)
	end
end

modifier_imba_track_cirt = class({})

function modifier_imba_track_cirt:IsDebuff()			return false end
function modifier_imba_track_cirt:IsHidden() 			return true end
function modifier_imba_track_cirt:IsPurgable() 			return false end
function modifier_imba_track_cirt:IsPurgeException() 	return false end

function modifier_imba_track_cirt:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE} end

function modifier_imba_track_cirt:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() and keys.target:HasModifier("modifier_imba_track") then
		return self:GetAbility():GetSpecialValueFor("crit_percentage") + self:GetParent():TG_GetTalentValue("special_bonus_imba_bounty_hunter_7")
		
		
	end
end



modifier_imba_track = class({})
function modifier_imba_track:IsDebuff()	return true end
function modifier_imba_track:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_track:RemoveOnDeath() return true end
function modifier_imba_track:IsHidden() return self:GetStackCount() == 1 end
function modifier_imba_track:IsPurgable() return self:GetStackCount() ~= 1 end
function modifier_imba_track:IsPurgeException() return self:GetStackCount() ~= 1 end
function modifier_imba_track:CheckState() return self:GetParent():HasModifier("modifier_imba_shadow_dance_effect") and nil or {[MODIFIER_STATE_INVISIBLE] = false} end
function modifier_imba_track:DeclareFunctions() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_PROVIDES_FOW_POSITION, MODIFIER_EVENT_ON_HERO_KILLED} end
function modifier_imba_track:GetModifierProvidesFOWVision() return 1 end
function modifier_imba_track:GetModifierIncomingDamage_Percentage() return (self:GetStackCount() == 1 and not self:GetParent():IsMagicImmune()) and self:GetAbility():GetSpecialValueFor("bonus_damage_scepter") or 0 end

function modifier_imba_track:OnHeroKilled(keys)
	if not IsServer() then
		return
	end
	if keys.target ~= self:GetParent() then
		return
	end
	if not keys.target:IsRealHero() or keys.reincarnate then
		return
	end
	local target = self:GetParent()
	local caster = self:GetCaster()
	local ally_gold = self:GetAbility():GetSpecialValueFor("bonus_gold") + keys.target:GetLevel() * self:GetAbility():GetSpecialValueFor("bonus_gold_per_lvl")
	local self_gold = self:GetAbility():GetSpecialValueFor("bonus_gold_self") + keys.target:GetLevel() * self:GetAbility():GetSpecialValueFor("bonus_gold_self_per_lvl")
	local total_ally = 0
	if caster:Has_Aghanims_Shard() then
		local g=(0 - (target:GetLevel()*50))
		PlayerResource:ModifyGold(target:GetPlayerOwnerID(),g , false, DOTA_ModifyGold_Unspecified)
	end
	local allies = FindUnitsInRadius(caster:GetTeamNumber(),
									self:GetParent():GetAbsOrigin(),
									nil,
									self:GetAbility():GetSpecialValueFor("aura_radius"),
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_HERO,
									DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
									FIND_ANY_ORDER,
									false)
--	local has = HeroItems:UnitHasItem(caster, "ti6_hunters_hoard_model")
	for _,ally in pairs(allies) do
		if ally ~= caster and ally:IsTrueHero() then
			ally:ModifyGold(ally_gold, true, 0)
			total_ally = total_ally + 1
			SendOverheadEventMessage(ally, OVERHEAD_ALERT_GOLD, ally, ally_gold, ally:GetPlayerOwner())
			if has then
				local pfx = ParticleManager:CreateParticle("particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_track_reward.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt(pfx, 2, ally, PATTACH_ABSORIGIN_FOLLOW, nil, ally:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 3, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(pfx)
			end
		end
	end
	caster:ModifyGold(self_gold, true, 0)
	SendOverheadEventMessage(caster, OVERHEAD_ALERT_GOLD, caster, self_gold, caster:GetPlayerOwner())
	if caster:TG_HasTalent("special_bonus_imba_bounty_hunter_8") then
		local ability = caster:FindAbilityByName("imba_bounty_hunter_shadow_jaunt")
		if ability and ability:GetLevel() > 0 then
			ability:EndCooldown()
		end
	end
	self:Destroy()
end

function modifier_imba_track:OnCreated()
	if self:GetAbility() == nil then return end
	if IsServer() then
		local target = self:GetParent()
		local caster = self:GetCaster()
		local pfx_name1 = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail.vpcf"
		local pfx_name2 = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf"
	--	if HeroItems:UnitHasItem(caster, "ti6_hunters_hoard_model") then
			pfx_name1 = "particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_track_trail.vpcf"
			pfx_name2 = "particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_shield.vpcf"
		--end
		local pfx1 = ParticleManager:CreateParticleForTeam(pfx_name1, PATTACH_POINT_FOLLOW, target, caster:GetTeamNumber())
		ParticleManager:SetParticleControlEnt(pfx1, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx1, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		local pfx2 = ParticleManager:CreateParticleForTeam(pfx_name2, PATTACH_OVERHEAD_FOLLOW, target, caster:GetTeamNumber())
		self:AddParticle(pfx1, false, false, 15, false, false)
		self:AddParticle(pfx2, false, false, 15, false, false)
	--	if self:GetCaster():HasTalent("special_bonus_imba_bounty_hunter_1") then
	--		self:StartIntervalThink(0.1)
	--	end
	end
end



modifier_imba_track_aura = class({})

function modifier_imba_track_aura:IsDebuff()	return true end
function modifier_imba_track_aura:IsHidden()	return true end
function modifier_imba_track_aura:IsPurgable()	return false end
function modifier_imba_track_aura:IsPurgeException()	return false end

function modifier_imba_track_aura:IsAura() return true end
function modifier_imba_track_aura:GetAuraDuration() return 0.5 end
function modifier_imba_track_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_imba_track_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_track_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_track_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_track_aura:GetModifierAura() return "modifier_imba_track_speed" end

function modifier_imba_track_aura:OnCreated()
	if self:GetAbility() == nil then return end
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_track_aura:OnIntervalThink()
	if not self:GetParent():HasModifier("modifier_imba_track") then
		self:Destroy()
	end
end

modifier_imba_track_speed = class({})

function modifier_imba_track_speed:IsDebuff()			return false end
function modifier_imba_track_speed:IsHidden() 			return false end
function modifier_imba_track_speed:IsPurgable() 		return false end
function modifier_imba_track_speed:IsPurgeException() 	return false end

function modifier_imba_track_speed:OnCreated()
	if self:GetAbility() == nil then return end
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_haste.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 2, self:GetParent():GetAbsOrigin())
		self:AddParticle(pfx, false, false, -1, false, false)
	end
end