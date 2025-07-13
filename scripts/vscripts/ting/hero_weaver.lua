shukuchi = class({})
LinkLuaModifier("modifier_shukuchi", "ting/hero_weaver", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_shukuchi_shard", "ting/hero_weaver", LUA_MODIFIER_MOTION_NONE) 

LinkLuaModifier("modifier_shukuchi_fade", "ting/hero_weaver", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_shukuchi_buff", "ting/hero_weaver", LUA_MODIFIER_MOTION_NONE) 
function shukuchi:IsHiddenWhenStolen() 		return false end
function shukuchi:IsRefreshable() 			return true end
function shukuchi:IsStealable() 				return true end
function shukuchi:OnSpellStart()
	EmitSoundOn("Hero_Weaver.Shukuchi",self:GetCaster())
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_shukuchi_fade",{duration = self:GetSpecialValueFor("fade_time")})
end


modifier_shukuchi_fade = class({})

function modifier_shukuchi_fade:IsDebuff()			return false end
function modifier_shukuchi_fade:IsHidden() 			return false end
function modifier_shukuchi_fade:IsPurgable() 			return false end
function modifier_shukuchi_fade:IsPurgeException() 	return false end

function modifier_shukuchi_fade:OnDestroy()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_shukuchi", {duration = self:GetAbility():GetSpecialValueFor("duration")})
	end
end

modifier_shukuchi = class({})

function modifier_shukuchi:IsDebuff()			return false end
function modifier_shukuchi:IsHidden() 
	return false
end		
function modifier_shukuchi:IsPurgable() 		return false end
function modifier_shukuchi:IsPurgeException() 	return false end
function modifier_shukuchi:CheckState() 
		return 
		{
			[MODIFIER_STATE_INVISIBLE] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_UNSLOWABLE]	= true,
			
			
		} 
end

function modifier_shukuchi:DeclareFunctions()
	return {MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,MODIFIER_EVENT_ON_ATTACK, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_DISABLE_AUTOATTACK, MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ABILITY_EXECUTED, MODIFIER_PROPERTY_INVISIBILITY_LEVEL}
end
function modifier_shukuchi:GetModifierInvisibilityLevel() 
	return 1
end
function modifier_shukuchi:GetModifierMoveSpeedBonus_Constant() 
	return self.speed
end
function modifier_shukuchi:GetModifierMoveSpeed_Limit()
    return self.speed_limit
end

function modifier_shukuchi:GetModifierIgnoreMovespeedLimit()
    return 1
end
function modifier_shukuchi:GetPriority()
    return	0
end
function modifier_shukuchi:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.speed = self.ab:GetSpecialValueFor("speed")
	self.speed_limit = self.ab:GetSpecialValueFor("speed_limit")
	if not IsServer() then return end
		if self.parent:HasModifier("modifier_veteran_talent_4_buff_2") then
			self.speed_limit = 99999
		end
		self.pfx = ParticleManager:CreateParticle("particles/econ/items/weaver/weaver_immortal_ti6/weaver_immortal_ti6_shukuchi.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.pfx, true, false, 15, false, false)

	self.att = true
	self:StartIntervalThink(0.1)
end


function modifier_shukuchi:OnIntervalThink()
	if IsServer() then		
		self.att = false
		if self.parent:IsMoving() then
			self.parent:AddNewModifier(self.parent,self.ab,"modifier_shukuchi_buff",{duration = 0.12})
		end
	end
end
function modifier_shukuchi:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end
function modifier_shukuchi:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and self:GetParent():IsRangedAttacker() and not self.att then
		self:Destroy()
	end
end

function modifier_shukuchi:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self.parent and not self:GetParent():IsRangedAttacker() then
		self:Destroy()
	end
end

function modifier_shukuchi:OnAbilityExecuted(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	local ability = self:GetParent():FindAbilityByName("shukuchi")
	if keys.ability == ability  then
		return
	end
	self:Destroy()
end
function modifier_shukuchi:OnDestroy()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(),self.ab,"modifier_shukuchi_shard",{duration = 1})
		self:GetParent():AddNewModifier(self:GetParent(),self.ab,"modifier_shukuchi_buff",{duration = 1})		
	end
end



modifier_shukuchi_shard = class({})

function modifier_shukuchi_shard:IsDebuff()			return false end
function modifier_shukuchi_shard:IsHidden() 
	return false
end		
function modifier_shukuchi_shard:IsPurgable() 		return false end
function modifier_shukuchi_shard:IsPurgeException() 	return false end
function modifier_shukuchi_shard:CheckState() 
		return 
		{
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_UNSLOWABLE]	= true,			
		} 
end

function modifier_shukuchi_shard:DeclareFunctions()
	return {MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT, MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT}
end

function modifier_shukuchi_shard:GetModifierMoveSpeedBonus_Constant() 
	return self.speed
end
function modifier_shukuchi_shard:GetModifierMoveSpeed_Limit()
    return self.speed_limit
end

function modifier_shukuchi_shard:GetModifierIgnoreMovespeedLimit()
    return 1
end
function modifier_shukuchi_shard:GetPriority()
    return	0
end
function modifier_shukuchi_shard:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.speed = self.ab:GetSpecialValueFor("speed")
	self.speed_limit = self.ab:GetSpecialValueFor("speed_limit")
	if not IsServer() then return end
		if self.parent:HasModifier("modifier_veteran_talent_4_buff_2") then
			self.speed_limit = 99999
		end
		self.pfx = ParticleManager:CreateParticle("particles/econ/items/weaver/weaver_immortal_ti6/weaver_immortal_ti6_shukuchi.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.pfx, true, false, 15, false, false)
end



modifier_shukuchi_buff=class({})

function modifier_shukuchi_buff:IsHidden() 			
    return true 
end

function modifier_shukuchi_buff:IsPurgable() 			
    return false 
end

function modifier_shukuchi_buff:IsPurgeException() 	
    return false 
end

function modifier_shukuchi_buff:RemoveOnDeath() 	
    return true 
end
--[[
function modifier_shukuchi_buff:CheckState() 	
    return {
		[MODIFIER_STATE_UNTARGETABLE_ENEMY]= true	
	}
end]]
function modifier_shukuchi_buff:DeclareFunctions() return {MODIFIER_PROPERTY_ABSORB_SPELL} end
function modifier_shukuchi_buff:GetAbsorbSpell(keys)
	if not IsServer() then
		return
	end
	if Is_Chinese_TG(keys.ability:GetCaster(), self:GetParent())then
		return 0
	end
	keys.ability:EndCooldown()
	if self:GetCaster():Has_Aghanims_Shard() then
		keys.ability:StartCooldown(5)
	end
	return 1
end