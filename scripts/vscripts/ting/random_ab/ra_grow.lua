ra_grow = class({})
LinkLuaModifier("modifier_ra_grow_pa", "ting/random_ab/ra_grow", LUA_MODIFIER_MOTION_NONE)
function ra_grow:GetIntrinsicModifierName() return "modifier_ra_grow_pa" end

--被动回蓝
modifier_ra_grow_pa=class({})
function modifier_ra_grow_pa:IsHidden() return false end
function modifier_ra_grow_pa:IsPurgable() return false end
function modifier_ra_grow_pa:IsPurgeException() return false end
function modifier_ra_grow_pa:RemoveOnDeath() return false end
function modifier_ra_grow_pa:DeclareFunctions() return 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	} 
end
function modifier_ra_grow_pa:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()*4
end
function modifier_ra_grow_pa:GetModifierPhysicalArmorBonus()
	return self:GetStackCount()*1.5
end
function modifier_ra_grow_pa:GetModifierConstantHealthRegen()
	return 200
end

function modifier_ra_grow_pa:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.parent = self:GetParent()
	if IsServer() then
		local time_minute = math.ceil(GameRules:GetGameTime()/60)
					
					self:SetStackCount(time_minute)
	end
end

