ra_bloodstone = class({})
LinkLuaModifier("modifier_ra_bloodstone_pa", "ting/random_ab/ra_bloodstone", LUA_MODIFIER_MOTION_NONE)
function ra_bloodstone:GetIntrinsicModifierName() return "modifier_ra_bloodstone_pa" end
function ra_bloodstone:IsHiddenWhenStolen() 		return false end
function ra_bloodstone:IsStealable() return false end
function ra_bloodstone:OnSpellStart()
	local caster = self:GetCaster()
	local stack = self:GetSpecialValueFor("stack")
	
		caster:EmitSound("DOTA_Item.Bloodstone.Cast")
		TG_Kill(caster, caster, self)
		local particle = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_tgt_death_v2_flowers.vpcf", PATTACH_POINT, caster)
		ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
	
end


--被动复活时间
modifier_ra_bloodstone_pa=class({})
function modifier_ra_bloodstone_pa:IsHidden() return false end
function modifier_ra_bloodstone_pa:IsPurgable() return false end
function modifier_ra_bloodstone_pa:IsPurgeException() return false end
function modifier_ra_bloodstone_pa:RemoveOnDeath() return false end
function modifier_ra_bloodstone_pa:GetModifierPercentageRespawnTime() 
	return self.ab:GetSpecialValueFor("retime")*0.01
end
function modifier_ra_bloodstone_pa:DeclareFunctions() 
	return 
	{
		MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE,
		 MODIFIER_EVENT_ON_DEATH,
	}
end
function modifier_ra_bloodstone_pa:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()  
	self.parent = self:GetParent()

end
function modifier_ra_bloodstone_pa:OnDeath(tg)
    if not IsServer() then
        return
    end
    if tg.unit == self.parent and not self.parent:IsIllusion() then
        local item = self.parent:FindItemInInventory("item_bloodstone")
		if item and not item:IsInBackpack() then
			item:SetCurrentCharges(item:GetCurrentCharges() + 2)
		end
        
    end
end
