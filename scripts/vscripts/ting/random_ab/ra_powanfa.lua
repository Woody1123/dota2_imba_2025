ra_powanfa = class({})
LinkLuaModifier("modifier_ra_powanfa_pa", "ting/random_ab/ra_powanfa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veteran_talent_2_buff", "modifier/veteran_talent/modifier_veteran_talent_2.lua", LUA_MODIFIER_MOTION_NONE )
function ra_powanfa:GetIntrinsicModifierName() return "modifier_ra_powanfa_pa" end

--被动回蓝
modifier_ra_powanfa_pa=class({})
function modifier_ra_powanfa_pa:IsHidden() return false end
function modifier_ra_powanfa_pa:IsPurgable() return false end
function modifier_ra_powanfa_pa:IsPurgeException() return false end
function modifier_ra_powanfa_pa:RemoveOnDeath() return false end



function modifier_ra_powanfa_pa:DeclareFunctions() return 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	} 
end


function modifier_ra_powanfa_pa:GetModifierIncomingDamage_Percentage(keys)
	
	if not IsServer() then return end
	if keys.target~=self.parent then return end
	if not keys.target:CanEntityBeSeenByMyTeam(keys.attacker) then
		self.damage = keys.damage+self.damage
		if self.damage>self.damage_limit then
			self.damage = 0
			self.parent:Purge(false, true, false, true, true)
			self.parent:AddNewModifier(self.parent,self.ab,"modifier_veteran_talent_2_buff",{duration = self.ab:GetSpecialValueFor("bkb_dur")})
		end
		return -80
	end
end



function modifier_ra_powanfa_pa:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.parent = self:GetParent()
	self.damage_limit = 8000
	self.damage = 0
end
