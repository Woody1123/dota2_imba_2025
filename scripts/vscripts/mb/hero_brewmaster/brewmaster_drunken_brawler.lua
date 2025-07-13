--brewmaster_drunken_brawler  醉拳
--酒仙被动获得一定几率闪避物理攻击并能造成致命一击。
--主动施放后进入醉拳状态，闪避攻击和致命一击的几率得到提升。
--酒仙的自身移动速度将持续变化，从-%min_movement%%%到%max_movement%%%。持续%duration%秒。
--imba 1.醉荡步: 主动施放后持续时间内闪避一切物理攻击.
--     2.踢连环: 主动施放期间每击杀一英雄单位,醉拳效果延长1s.

function IsUnit(BaseNPC)
	return BaseNPC:IsHero() or BaseNPC:IsCreep() or BaseNPC:IsBoss()
end

imba_brewmaster_drunken_brawler = class({})

LinkLuaModifier("modifier_imba_brewmaster_drunken_brawler_passive","mb/hero_brewmaster/brewmaster_drunken_brawler.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_drunken_brawler_active","mb/hero_brewmaster/brewmaster_drunken_brawler.lua", LUA_MODIFIER_MOTION_NONE)

function imba_brewmaster_drunken_brawler:IsHiddenWhenStolen() 	return false end
function imba_brewmaster_drunken_brawler:IsRefreshable() 		return true end
function imba_brewmaster_drunken_brawler:IsStealable() 			return true end
function imba_brewmaster_drunken_brawler:GetIntrinsicModifierName() return "modifier_imba_brewmaster_drunken_brawler_passive" end

function imba_brewmaster_drunken_brawler:OnSpellStart()
	local caster        = self:GetCaster()
	local ability       = self
	local duration      = self:GetSpecialValueFor("duration")
	local brawler_sound = "Hero_Brewmaster.Brawler.Cast"
	local pos           = self:GetCaster():GetAbsOrigin()
	--开始音效
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), brawler_sound, caster)
	--暴击和闪避修饰器 移速限制修改器
	caster:AddNewModifier(
				caster, 
				ability, 
				"modifier_imba_brewmaster_drunken_brawler_active", 
				{duration = duration}
			)
end

--醉拳主动
modifier_imba_brewmaster_drunken_brawler_active = class({})

function modifier_imba_brewmaster_drunken_brawler_active:IsDebuff()			return false end
function modifier_imba_brewmaster_drunken_brawler_active:IsHidden() 		return false end
function modifier_imba_brewmaster_drunken_brawler_active:IsPurgable() 		return true end
--醉拳特效
function modifier_imba_brewmaster_drunken_brawler_active:GetEffectName() return "particles/units/heroes/hero_brewmaster/brewmaster_drunkenbrawler_crit.vpcf" end
function modifier_imba_brewmaster_drunken_brawler_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_brewmaster_drunken_brawler_active:DeclareFunctions()	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_EVENT_ON_HERO_KILLED,MODIFIER_PROPERTY_AVOID_DAMAGE} end
--移速
function modifier_imba_brewmaster_drunken_brawler_active:GetModifierMoveSpeedBonus_Percentage() return	self:GetAbility():GetSpecialValueFor("max_movement") end
--IMBA
function modifier_imba_brewmaster_drunken_brawler_active:OnHeroKilled(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() and keys.target:IsHero() then 
		self:SetDuration(self:GetRemainingTime() + self:GetAbility():GetSpecialValueFor("active_extend"),true)
	end
end
--避免物理伤害
function modifier_imba_brewmaster_drunken_brawler_active:GetModifierAvoidDamage(tg) 
	if self:GetAbility() ~= nil and tg.target==self:GetParent() and (tg.damage_type == DAMAGE_TYPE_PHYSICAL) then return 1 end
	return 0 
end

--暴击和闪避修饰器 移速限制修改器
modifier_imba_brewmaster_drunken_brawler_passive = class({})

function modifier_imba_brewmaster_drunken_brawler_passive:IsDebuff()			return false end
function modifier_imba_brewmaster_drunken_brawler_passive:IsHidden() 			return true end
function modifier_imba_brewmaster_drunken_brawler_passive:IsPurgable() 		return false end
function modifier_imba_brewmaster_drunken_brawler_passive:IsPurgeException() 	return false end
function modifier_imba_brewmaster_drunken_brawler_passive:DeclareFunctions()	return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_ATTACK_FAIL,MODIFIER_PROPERTY_EVASION_CONSTANT} end
function modifier_imba_brewmaster_drunken_brawler_passive:OnCreated() self.crit = {} end
function modifier_imba_brewmaster_drunken_brawler_passive:OnDestroy() self.crit = nil end
--暴击
function modifier_imba_brewmaster_drunken_brawler_passive:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() and keys.attacker == self:GetParent() and IsUnit(keys.target) and not self:GetParent():PassivesDisabled() then
		local brewmaster = self:GetParent()
		local ability = self:GetAbility()
		local crit_chance = ability:GetSpecialValueFor("crit_chance") 
		if brewmaster:HasModifier("modifier_imba_brewmaster_drunken_brawler_active") then 
			crit_chance = crit_chance * ability:GetSpecialValueFor("active_multiplier")
		end
		if PseudoRandom:RollPseudoRandom(ability, crit_chance) or brewmaster:HasModifier("modifier_imba_brewmaster_fire_buff") then
			self.crit[keys.record] = true
			if brewmaster:TG_HasTalent("special_bonus_imba_brewmaster_4") then
				return (ability:GetSpecialValueFor("crit_multiplier") + brewmaster:TG_GetTalentValue("special_bonus_imba_brewmaster_4"))
			else
				return (ability:GetSpecialValueFor("crit_multiplier"))
			end
		end
		return 0 
	end
end

function modifier_imba_brewmaster_drunken_brawler_passive:OnAttackFail(keys) self.crit[keys.record] = nil end
function modifier_imba_brewmaster_drunken_brawler_passive:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	if self.crit[keys.record] then
		--暴击音效
		self:GetParent():EmitSound("Hero_Brewmaster.Brawler.Crit")
		--暴击特效
		--local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		--ParticleManager:ReleaseParticleIndex(pfx)
	end
	self.crit[keys.record] = nil
end
--闪避
function modifier_imba_brewmaster_drunken_brawler_passive:GetModifierEvasion_Constant() 
	if self:GetParent():HasModifier("modifier_imba_brewmaster_drunken_brawler_active") and self:GetAbility() ~= nil then 
		return	self:GetAbility():GetSpecialValueFor("dodge_chance") * self:GetAbility():GetSpecialValueFor("active_multiplier")
	end
	return	self:GetAbility():GetSpecialValueFor("dodge_chance") 
end
